/*
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

package com.raywenderlich.android.datadrop.ui.droplist

import android.support.v7.util.DiffUtil
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import com.raywenderlich.android.datadrop.R
import com.raywenderlich.android.datadrop.app.inflate
import com.raywenderlich.android.datadrop.model.Drop
import kotlinx.android.synthetic.main.list_item_drop.view.*


class DropListAdapter(private val drops: MutableList<Drop>, private val listener: DropListAdapterListener)
  : RecyclerView.Adapter<DropListAdapter.ViewHolder>(), ItemTouchHelperListener {

  override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
    return ViewHolder(parent.inflate(R.layout.list_item_drop))
  }

  override fun getItemCount() = drops.size

  override fun onBindViewHolder(holder: ViewHolder, position: Int) {
    holder.bind(drops[position])
  }

  fun updateDrops(drops: List<Drop>) {
    val diffCallback = DropDiffCallback(this.drops, drops)
    val diffResult = DiffUtil.calculateDiff(diffCallback)

    this.drops.clear()
    this.drops.addAll(drops)
    diffResult.dispatchUpdatesTo(this)
  }

  fun removeDropAtPosition(position: Int) {
    drops.removeAt(position)
    notifyItemRemoved(position)
  }

  override fun onItemDismiss(viewHolder: RecyclerView.ViewHolder, position: Int) {
    listener.deleteDropAtPosition(drops[position], position)
  }

  inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

    private lateinit var drop: Drop

    fun bind(drop: Drop) {
      this.drop = drop
      itemView.message.text = drop.dropMessage
      itemView.latlng.text = drop.latLngString()
    }
  }

  interface DropListAdapterListener {
    fun deleteDropAtPosition(drop: Drop, position: Int)
  }
}
