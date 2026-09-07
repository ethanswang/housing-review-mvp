'use server'

import { revalidatePath } from 'next/cache'
import { insertReview } from '@/lib/queries'
import { RATING_KEYS } from '@/lib/types'

export type ReviewFormState = { error: string | null; success: boolean }

/**
 * Server Action: runs only on the server, invoked by the review <form>.
 *
 * Validation lives here rather than only in the browser because a Server Action
 * is reachable by a direct POST — client-side `required` attributes are a
 * convenience, not a guard. Postgres CHECK constraints (see schema.sql) are the
 * third and final layer.
 */
export async function submitReview(
  _prevState: ReviewFormState,
  formData: FormData
): Promise<ReviewFormState> {
  const propertyId = String(formData.get('property_id') ?? '')
  const slug = String(formData.get('slug') ?? '')
  const body = String(formData.get('body') ?? '').trim()
  const leaseTerm = String(formData.get('lease_term') ?? '').trim()

  if (!propertyId || !slug) return { error: 'Something went wrong. Please reload and try again.', success: false }

  const ratings = {} as Record<(typeof RATING_KEYS)[number], number>
  for (const key of RATING_KEYS) {
    const score = Number(formData.get(key))
    if (!Number.isInteger(score) || score < 1 || score > 5) {
      return { error: 'Please rate all four categories.', success: false }
    }
    ratings[key] = score
  }

  if (!leaseTerm) return { error: 'Please say which lease year this was.', success: false }
  if (body.length < 20) return { error: 'Please write at least 20 characters so the review is useful.', success: false }
  if (body.length > 2000) return { error: 'Please keep your review under 2000 characters.', success: false }

  await insertReview({ property_id: propertyId, ...ratings, body, lease_term: leaseTerm })

  // Drop the cached render of both pages so the new review and the recomputed
  // averages appear immediately.
  revalidatePath(`/properties/${slug}`)
  revalidatePath('/')

  return { error: null, success: true }
}
